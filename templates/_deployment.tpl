{{- define "common.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: {{ .Values.namespace }}
  name: {{ .Release.Name }}
  labels:
    app.kubernetes.io/name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .Release.Name }}
    spec:
      serviceAccountName: {{ .Values.service.accountName }}
      terminationGracePeriodSeconds: 70
      containers:
        - name: {{ .Release.Name }}
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          env:
            - name: ASPNETCORE_ENVIRONMENT
              value: {{ .Values.environment }}
            - name: CONFIGURATION_MANAGER_URI
              value: {{ .Values.configurationManagerUri }}
          ports:
            - containerPort: {{ .Values.service.targetPort }}
          lifecycle:
            preStop:
              exec:
                command:
                  - /bin/sh
                  - '-c'
{{- end -}}