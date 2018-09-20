#! /bin/sh

eval $(minishift oc-env) && eval $(minishift docker-env)
oc login $(minishift ip):8443 -u admin -p admin 1>/dev/null

if [ "${RESET}" ]
then
    echo resetting
    wsk -i action delete conversions/temperature
    wsk -i package delete conversions
    wsk -i package delete kelvin
fi


AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode) 1> /dev/null
wsk -i property set --auth ${AUTH_SECRET} --apihost $(oc get route/openwhisk --template="{{.spec.host}}") 1> /dev/null

wsk -i package list /whisk.system

wsk -i package get --summary /whisk.system/alarms

wsk -i package update conversions

wsk -i package list | grep conversions

### Step 2

cat > temperature.js <<TEMP
function normalize(value, scale) {
    switch(scale) {
        case "C":
            converted = value
            break;
        case "F":
            converted = (value - 32) / 1.8
            break;
        case "K":
            converted = value - 273.15
            break;
        default:
            converted = null
    }

    return converted
}

function main(args) {
    temperature = args.temperature
    scale = args.scale
    target = args.target

    switch (target) {
        case "C":
            converted = normalize(temperature, scale)
            break;
        case "F":
            converted = normalize(temperature, scale) * 1.8 + 32
            break;
        case "K":
            converted = normalize(temperature, scale) + 273.15
            break;
        default:
            converted = null
            break;
    }

    return { "result": temperature + scale + " is " + converted + target }
}
TEMP

wsk -i action update conversions/temperature temperature.js

wsk -i action invoke --blocking --result conversions/temperature --param temperature 212 --param scale F --param target K

wsk -i action invoke --blocking --result conversions/temperature --param temperature 100 --param scale C --param target F

wsk -i action invoke --blocking --result conversions/temperature --param temperature -40 --param scale F --param target C

###  Step 3

wsk -i action update conversions/temperature --param target C

wsk -i action invoke --blocking --result conversions/temperature --param temperature 212 --param scale F

wsk -i action update conversions/temperature --param target C --param scale F

wsk -i action invoke --blocking --result conversions/temperature --param temperature 212

wsk -i action invoke --blocking --result conversions/temperature --param temperature 100 --param scale C --param target K

wsk -i action delete conversions/temperature
wsk -i action update conversions/temperature temperature.js

wsk -i action invoke --blocking --result conversions/temperature --param temperature 212

wsk -i package update conversions --param target C --param scale F

wsk -i action invoke --blocking --result conversions/temperature --param temperature 212
wsk -i action invoke --blocking --result conversions/temperature --param temperature 212 --param target K

### Step 4

cat > parameters.json <<JSON
{
    "temperature": 0,
    "scale": "K"
}
JSON

wsk -i action invoke --blocking --result conversions/temperature --param-file parameters.json

wsk -i package bind /whisk.system/conversions kelvin --param scale K

wsk -i package get --summary kelvin

wsk -i action invoke --blocking --result kelvin/temperature --param temperature 0

### Step 5
wsk -i package get conversions publish

wsk -i package update conversions --shared yes

wsk -i package get conversions publish

wsk -i package list /whisk.system

wsk -i package update conversions --shared no
wsk -i package list /whisk.system

### Done

rm temperature.js parameters.json