At some point when you are developing your microservice architecture, you will need to visualize what is happening in your service mesh. You will have questions like “Which service is connected to which other service?” and “How much traffic goes to each microservice?” But because of the loosely tied nature of microservice architectures , these questions can be difficult to answer.

Those are the kinds of question that Kiali has the ability to answer, by giving you a big picture of the mesh, and showing the whole flow of your requests and data.

Kiali builds upon the same concepts as Istio, and you can check the [glossary](https://www.kiali.io/documentation/glossary/concepts/) for a refresher.