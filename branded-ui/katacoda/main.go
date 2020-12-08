package main

import (
	rice "github.com/GeertJohan/go.rice"
	"github.com/husobee/vestigo"
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

type CoursePageData struct {
	Name      string
	Subcourse string
}
type ScenarioPageData struct {
	Course CoursePageData
	Name   string
}

var templates = template.New("").Funcs(templateMap)
var templateBox *rice.Box

func newTemplate(path string, fileInfo os.FileInfo, _ error) error {
	if path == "" {
		return nil
	}
	if fileInfo.Mode().IsDir() {
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
	redirect := getRedirectUrl(vestigo.Param(r, "course"), "")
	if redirect != "" {
		http.Redirect(w, r, redirect, http.StatusTemporaryRedirect)
	} else {
		pageData := CoursePageData{Name: vestigo.Param(r, "course")}
		renderTemplate(w, "templates/course.html", &pageData)
	}
}

func subcourse(w http.ResponseWriter, r *http.Request) {
	pageData := CoursePageData{Name: vestigo.Param(r, "course"), Subcourse: vestigo.Param(r, "subcourse")}
	renderTemplate(w, "templates/subcourse.html", &pageData)
}

func scenario(w http.ResponseWriter, r *http.Request) {
	redirect := getRedirectUrl(vestigo.Param(r, "course"), vestigo.Param(r, "scenario"))
	if redirect != "" {
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
	pageData := CoursePageData{Name: "training"}
	renderTemplate(w, "templates/course.html", &pageData)
}

func trainingscenario(w http.ResponseWriter, r *http.Request) {
	redirect := getRedirectUrl(vestigo.Param(r, "course"), vestigo.Param(r, "scenario"))
	if redirect != "" {
		http.Redirect(w, r, redirect, http.StatusTemporaryRedirect)
	}
	pageData := ScenarioPageData{Name: vestigo.Param(r, "scenario"), Course: CoursePageData{Name: vestigo.Param(r, "course")}}
	renderTemplate(w, "templates/training-scenario.html", &pageData)
}

func index(w http.ResponseWriter, r *http.Request) {
	renderTemplate(w, "templates/index.html", nil)
}

func redirectMiddleware(h http.HandlerFunc) http.HandlerFunc {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {

		if(req.URL.Scheme == "https" || req.Header.Get("x-forwarded-proto") == "https") {
			h.ServeHTTP(w, req)
		} else {
			target := "https://" + req.Host + req.URL.Path
			
			if len(req.URL.Query()) > 0 {
				for k, _ := range req.URL.Query() {
					if(string(k[0]) != ":") { //Remove vestigo parameters
						if(strings.Contains(target, "?") == false) {
							target += "?"
						} else {
							target += "&"
						}
						target += k + "=" + req.URL.Query().Get(k);
					}
				}
			}
			log.Printf("redirecting http %s to: %s", req.URL.Scheme, target)
			http.Redirect(w, req, target, http.StatusTemporaryRedirect)
		}
	})
}


func main() {
	templateBox = rice.MustFindBox("templates")
	templateBox.Walk("/", newTemplate)

	router := vestigo.NewRouter()

	router.Get("/", redirectMiddleware(index))
	router.Get("/static/*", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))).ServeHTTP)
	router.Get("/:course", redirectMiddleware(course))
	router.Get("/:course/", redirectMiddleware(course))
	router.Get("/:course/courses/:subcourse", redirectMiddleware(subcourse))
	router.Get("/:course/courses/:subcourse/", redirectMiddleware(subcourse))
	router.Get("/training/", redirectMiddleware(traininghome))
	router.Get("/training/:course", redirectMiddleware(trainingcourse))
	router.Get("/training/:course/", redirectMiddleware(trainingcourse))
	router.Get("/training/:course/:scenario", redirectMiddleware(trainingscenario))
	router.Get("/:course/:scenario", redirectMiddleware(scenario))
	router.Get("/:course/:scenario/", redirectMiddleware(scenario))
	router.Get("/:course/courses/:subcourse/:scenario", redirectMiddleware(subcoursescenario))
	router.Get("/:course/courses/:subcourse/:scenario/", redirectMiddleware(subcoursescenario))
	http.Handle("/", router)

	log.Print("Listening on 0.0.0.0:3000...")
	log.Fatal(http.ListenAndServe("0.0.0.0:3000", nil))
}
