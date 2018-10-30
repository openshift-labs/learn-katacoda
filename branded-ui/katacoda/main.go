package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"

	rice "github.com/GeertJohan/go.rice"
	"github.com/husobee/vestigo"
)

type CoursePageData struct {
	Name  string
	Subcourse  string
}
type ScenarioPageData struct {
	Course CoursePageData
	Name  string
}

var templates = template.New("").Funcs(templateMap)
var templateBox *rice.Box

func newTemplate(path string, _ os.FileInfo, _ error) error {
	if path == "" {
		return nil
	}
	templateString, err := templateBox.String(path)
	if err != nil {
		log.Panicf("Unable to parse: path=%s, err=%s", path, err)
	}
	templates.New(filepath.Join("templates", path)).Parse(templateString)
	return nil
}

func renderTemplate(w http.ResponseWriter, tmpl string, p interface{}) {
	err := templates.ExecuteTemplate(w, tmpl, p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func course(w http.ResponseWriter, r *http.Request) {
	pageData := CoursePageData{Name: vestigo.Param(r, "course")}
	renderTemplate(w, "templates/course.html", &pageData)
}

func subcourse(w http.ResponseWriter, r *http.Request) {
	pageData := CoursePageData{Name: vestigo.Param(r, "course"), Subcourse: vestigo.Param(r, "subcourse")}
	renderTemplate(w, "templates/subcourse.html", &pageData)
}

func scenario(w http.ResponseWriter, r *http.Request) {
	redirect := getRedirectUrl(vestigo.Param(r, "course"), vestigo.Param(r, "scenario"))
	if(redirect != "") {
		http.Redirect(w, r, redirect, http.StatusTemporaryRedirect)
	}
 	pageData := ScenarioPageData{Name: vestigo.Param(r, "scenario"), Course: CoursePageData{Name: vestigo.Param(r, "course")}}
	renderTemplate(w, "templates/scenario.html", &pageData)
}

func subcoursescenario(w http.ResponseWriter, r *http.Request) {
 	pageData := ScenarioPageData{Name: vestigo.Param(r, "scenario"), Course: CoursePageData{Name: vestigo.Param(r, "course"), Subcourse: vestigo.Param(r, "subcourse")}}
	renderTemplate(w, "templates/subcoursescenario.html", &pageData)
}

func trainingcourse(w http.ResponseWriter, r *http.Request) {
	pageData := CoursePageData{Name: "training/" + vestigo.Param(r, "course")}
	renderTemplate(w, "templates/course.html", &pageData)
}

func traininghome(w http.ResponseWriter, r *http.Request) {
	pageData := CoursePageData{Name: "training" }
	renderTemplate(w, "templates/course.html", &pageData)
}

func trainingscenario(w http.ResponseWriter, r *http.Request) {
	redirect := getRedirectUrl(vestigo.Param(r, "course"), vestigo.Param(r, "scenario"))
	if(redirect != "") {
		http.Redirect(w, r, redirect, http.StatusTemporaryRedirect)
	}
 	pageData := ScenarioPageData{Name: vestigo.Param(r, "scenario"), Course: CoursePageData{Name: vestigo.Param(r, "course")}}
	renderTemplate(w, "templates/training-scenario.html", &pageData)
}


func index(w http.ResponseWriter, r *http.Request) {
	renderTemplate(w, "templates/index.html", nil)
}

func main() {
	templateBox = rice.MustFindBox("templates")
	templateBox.Walk("", newTemplate)

	router := vestigo.NewRouter()

	router.Get("/", index)
	router.Get("/static/*", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))).ServeHTTP)
	router.Get("/:course", course)
	router.Get("/:course/", course)
	router.Get("/:course/courses/:subcourse", subcourse)
	router.Get("/:course/courses/:subcourse/", subcourse)
	router.Get("/training/", traininghome)
	router.Get("/training/:course", trainingcourse)
	router.Get("/training/:course/", trainingcourse)
	router.Get("/training/:course/:scenario", trainingscenario)
	router.Get("/:course/:scenario", scenario)
	router.Get("/:course/:scenario/", scenario)
	router.Get("/:course/courses/:subcourse/:scenario", subcoursescenario)
	router.Get("/:course/courses/:subcourse/:scenario/", subcoursescenario)
	http.Handle("/", router)

	log.Print("Listening on 0.0.0.0:3000...")
	log.Fatal(http.ListenAndServe("0.0.0.0:3000", nil))
}
