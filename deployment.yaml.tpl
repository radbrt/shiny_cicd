apiVersion: apps/v1
kind: Deployment
metadata:
  name: shinyweb
spec:
  selector:
    matchLabels:
      app: shinyweb
  replicas: 3
  template: # template for the pods
    metadata:
      labels:
        app: shinyweb
    spec:
      containers:
      - name: shiny
        image: gcr.io/GOOGLE_CLOUD_PROJECT/github.com/radbrt/shiny_cicd:SHORT_SHA
        imagePullPolicy: "Always"
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5

---
kind: Service
apiVersion: v1
metadata:
  name: shinynet
spec:
  selector:
    app: shinyweb
  ports:
    - name: shinyport
      port: 3838
  type: LoadBalancer
