{{/*
Expand the name of the chart.
*/}}
{{- define "adjustapi-apps.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "adjustapi-apps.fullname" -}}
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
{{- define "adjustapi-apps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "adjustapi-apps.labels" -}}
helm.sh/chart: {{ include "adjustapi-apps.chart" . }}
{{ include "adjustapi-apps.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
All labels
*/}}
{{- define "adjustapi-apps.allLabels" -}}
{{ include "adjustapi-apps.labels" . }}
{{- if .Values.commonLabels }}
{{ toYaml .Values.commonLabels }}
app: {{ .Values.deployment.name }}
cluster: {{ .Values.cluster_name}}
meta.helm.sh/release-name: {{ .Values.deployment.name }}
{{- end }}
{{- if .Values.additionalLabels }}
{{- toYaml .Values.additionalLabels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "adjustapi-apps.selectorLabels" -}}
env: {{ .Values.environment }}
type: {{ .Values.type }}
{{- end }}

{{/*
Returns probe definition based on user settings and default HTTP port.
Accepts a map with `port` (default port), `path` (probe handler URI) and `settings` (probe settings).
*/}}
{{- define "probe.http" -}}
{{- if or .settings.httpGet .settings.tcpSocket .settings.exec -}}
{{ toYaml .settings }}
{{- else -}}
{{- $handler := dict "httpGet" (dict "port" .port "path" .path "scheme" "HTTP") -}}
{{ toYaml (merge $handler .settings) }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "adjustapi-apps.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "adjustapi-apps.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}