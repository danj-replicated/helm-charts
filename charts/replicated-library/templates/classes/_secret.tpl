{{/*
This template serves as a blueprint for all secret objects that are created
within the replicated-library library.
*/}}
{{- define "replicated-library.classes.secret" -}}
  {{- $secretName := include "replicated-library.names.fullname" . -}}
  {{- $values := .Values.secrets -}}

  {{- if hasKey . "ObjectName" -}}
    {{- $secretName = .ObjectName -}}
  {{ end -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.values -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "replicated-library.names.fullname" . }}
  {{- with (merge ($values.labels | default dict) (include "replicated-library.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "replicated-library.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
stringData:
{{- with $values.data }}
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- end }}
