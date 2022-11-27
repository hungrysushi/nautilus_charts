{{/*
Expand the name of the chart.
*/}}
{{- define "shipyard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "shipyard.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "shipyard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "shipyard.labels" -}}
helm.sh/chart: {{ include "shipyard.chart" . }}
{{ include "shipyard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "shipyard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shipyard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "shipyard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shipyard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Namespace to install ArgoCD apps
*/}}
{{- define "shipyard.namespace" -}}
{{- .Values.namespace | default .Values.global.argocd.namespace }}
{{- end }}

{{/*
Destination namespace for chart
*/}}
{{- define "shipyard.fleet.destinationNamespace" -}}
{{- .ship.namespace | default (printf "%s-fleet-ship-%s" .root.Release.Name .ship.name) }}
{{- end }}


