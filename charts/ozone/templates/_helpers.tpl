{{/*
  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/}}

{{/* Common labels */}}
{{- define "ozone.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "ozone.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* List of comma separated SCM pod names */}}
{{- define "ozone.scm.pods" -}}
  {{- $pods := list }}
  {{- $replicas := .Values.scm.replicas | int }}
  {{- range $i := until $replicas }}
    {{- $pods = append $pods (printf "%s-scm-%d.%s-scm-headless" $.Release.Name $i $.Release.Name) }}
  {{- end }}
  {{- $pods | join "," }}
{{- end }}

{{/* List of comma separated OM pod names */}}
{{- define "ozone.om.pods" -}}
  {{- $pods := list }}
  {{- $replicas := .Values.om.replicas | int }}
  {{- range $i := until $replicas }}
    {{- $pods = append $pods (printf "%s-om-%d.%s-om-headless" $.Release.Name $i $.Release.Name) }}
  {{- end }}
  {{- $pods | join "," }}
{{- end }}

{{/* List of comma separated om ids */}}
{{- define "ozone.om.cluster.ids" -}}
  {{- $pods := list }}
  {{- $replicas := .Values.om.replicas | int }}
  {{- range $i := until $replicas }}
    {{- $pods = append $pods (printf "%s-om-%d" $.Release.Name $i) }}
  {{- end }}
  {{- $pods | join "," }}
{{- end }}

{{/* List of comma separated scm ids */}}
{{- define "ozone.scm.cluster.ids" -}}
  {{- $pods := list }}
  {{- $replicas := .Values.scm.replicas | int }}
  {{- range $i := until $replicas }}
    {{- $pods = append $pods (printf "%s-scm-%d" $.Release.Name $i) }}
  {{- end }}
  {{- $pods | join "," }}
{{- end }}

{{/* List of decommission om nodes */}}
{{- define "ozone.om.decommissioned.nodes" -}}
    {{- $nodes := list }}
    {{- $statefulset := lookup "apps/v1" "StatefulSet" $.Release.Namespace (printf "%s-om" $.Release.Name) -}}
    {{- if $statefulset }}
      {{- $oldCount := $statefulset.spec.replicas | int -}}
      {{- $newCount := .Values.om.replicas | int }}
        {{- range $i := until $oldCount }}
          {{- $minCount := max $newCount 1 -}}
          {{- if ge $i $minCount }}
            {{- $nodes = append $nodes (printf "%s-om-%d" $.Release.Name $i) }}
          {{- end }}
        {{- end }}
    {{- end }}
    {{- $nodes | join "," }}
{{- end }}

{{/* List of bootstrap om nodes */}}
{{- define "ozone.om.bootstrap.nodes" -}}
    {{- $nodes := list }}
    {{- $statefulset := lookup "apps/v1" "StatefulSet" $.Release.Namespace (printf "%s-om" $.Release.Name) -}}
    {{- if $statefulset }}
      {{- $oldCount := $statefulset.spec.replicas | int -}}
      {{- $newCount := .Values.om.replicas | int }}
        {{- range $i := until $newCount }}
          {{- if ge $i $oldCount }}
            {{- $nodes = append $nodes (printf "%s-om-%d" $.Release.Name $i) }}
          {{- end }}
        {{- end }}
    {{- end }}
    {{- $nodes | join ","}}
{{- end }}

{{/* List of decommission scm nodes */}}
{{- define "ozone.scm.decommissioned.nodes" -}}
    {{- $nodes := list }}
    {{- $statefulset := lookup "apps/v1" "StatefulSet" $.Release.Namespace (printf "%s-scm" $.Release.Name) -}}
    {{- if $statefulset }}
      {{- $oldCount := $statefulset.spec.replicas | int -}}
      {{- $newCount := .Values.scm.replicas | int }}
        {{- range $i := until $oldCount }}
          {{- if ge $i $newCount }}
            {{- $nodes = append $nodes (printf "%s-scm-%d" $.Release.Name $i) }}
          {{- end }}
        {{- end }}
    {{- end }}
    {{- $nodes | join "," -}}
{{- end }}

{{/* List of decommission data nodes */}}
{{- define "ozone.data.decommissioned.hosts" -}}
    {{- $hosts := list }}
    {{- $statefulset := lookup "apps/v1" "StatefulSet" $.Release.Namespace (printf "%s-datanode" $.Release.Name) -}}
    {{- if $statefulset }}
      {{- $oldCount := $statefulset.spec.replicas | int -}}
      {{- $newCount := .Values.datanode.replicas | int }}
        {{- range $i := until $oldCount }}
          {{- if ge $i $newCount }}
            {{- $hosts = append $hosts (printf "%s-datanode-%d.%s-datanode-headless.%s.svc.cluster.local" $.Release.Name $i $.Release.Name $.Release.Namespace) }}
          {{- end }}
        {{- end }}
    {{- end }}
    {{- $hosts | join "," -}}
{{- end }}

{{- define "ozone.configuration.env.common" -}}
- name: OZONE-SITE.XML_hdds.datanode.dir
  value: /data/storage
- name: OZONE-SITE.XML_ozone.scm.datanode.id.dir
  value: /data
- name: OZONE-SITE.XML_ozone.metadata.dirs
  value: /data/metadata
- name: OZONE-SITE.XML_ozone.scm.ratis.enable
  value: "true"
- name: OZONE-SITE.XML_ozone.scm.service.ids
  value: cluster1
- name: OZONE-SITE.XML_ozone.scm.nodes.cluster1
  value: {{ include "ozone.scm.cluster.ids" . }}
  {{/*- name: OZONE-SITE.XML_ozone.scm.skip.bootstrap.validation*/}}
  {{/*  value: {{ quote .Values.scm.skipBootstrapValidation }}*/}}
{{- range $i, $val := until ( .Values.scm.replicas | int ) }}
- name: {{ printf "OZONE-SITE.XML_ozone.scm.address.cluster1.%s-scm-%d" $.Release.Name $i }}
  value: {{ printf "%s-scm-%d.%s-scm-headless.%s.svc.cluster.local" $.Release.Name $i $.Release.Name $.Release.Namespace }}
{{- end }}
- name: OZONE-SITE.XML_ozone.scm.primordial.node.id
  value: {{ printf "%s-scm-0" $.Release.Name }}
- name: OZONE-SITE.XML_ozone.om.ratis.enable
  value: "true"
- name: OZONE-SITE.XML_ozone.om.service.ids
  value: cluster1
- name: OZONE-SITE.XML_hdds.scm.safemode.min.datanode
  value: "3"
- name: OZONE-SITE.XML_ozone.datanode.pipeline.limit
  value: "1"
- name: OZONE-SITE.XML_dfs.datanode.use.datanode.hostname
  value: "true"
{{- end }}

{{/* Common configuration environment variables */}}
{{- define "ozone.configuration.env" -}}
{{- $bOmNodes := ternary (splitList "," (include "ozone.om.bootstrap.nodes" .)) (list) (ne "" (include "ozone.om.bootstrap.nodes" .)) }}
{{- $dOmNodes := ternary (splitList "," (include "ozone.om.decommissioned.nodes" .)) (list) (ne "" (include "ozone.om.decommissioned.nodes" .)) }}
{{- $activeOmNodes := ternary (splitList "," (include "ozone.om.cluster.ids" .)) (list) (ne "" (include "ozone.om.cluster.ids" .)) }}
{{ include "ozone.configuration.env.common" . }}
{{- if gt (len $dOmNodes) 0 }}
{{- $decomIds := $dOmNodes | join "," }}
- name: OZONE-SITE.XML_ozone.om.decommissioned.nodes.cluster1
  value: {{ $decomIds }}
{{- else}}
- name: OZONE-SITE.XML_ozone.om.decommissioned.nodes.cluster1
  value: ""
{{- end }}
- name: OZONE-SITE.XML_ozone.om.nodes.cluster1
  value: {{ $activeOmNodes | join "," }}
{{- range $tempId := $activeOmNodes }}
- name: {{ printf "OZONE-SITE.XML_ozone.om.address.cluster1.%s" $tempId }}
  value: {{ printf "%s.%s-om-headless.%s.svc.cluster.local" $tempId $.Release.Name $.Release.Namespace }}
{{- end }}
{{- range $tempId := $dOmNodes }}
- name: {{ printf "OZONE-SITE.XML_ozone.om.address.cluster1.%s" $tempId }}
  value: {{ printf "%s-helm-manager-decommission-%s-svc.%s.svc.cluster.local" $.Release.Name $tempId $.Release.Namespace }}
{{- end }}
{{- end }}

{{/* Common configuration environment variables for pre hook */}}
{{- define "ozone.configuration.env.prehook" -}}
{{- $bOmNodes := ternary (splitList "," (include "ozone.om.bootstrap.nodes" .)) (list) (ne "" (include "ozone.om.bootstrap.nodes" .)) }}
{{- $dOmNodes := ternary (splitList "," (include "ozone.om.decommissioned.nodes" .)) (list) (ne "" (include "ozone.om.decommissioned.nodes" .)) }}
{{- $activeOmNodes := ternary (splitList "," (include "ozone.om.cluster.ids" .)) (list) (ne "" (include "ozone.om.cluster.ids" .)) }}
{{- $allOmNodes := concat $activeOmNodes $dOmNodes }}
{{ include "ozone.configuration.env.common" . }}
- name: OZONE-SITE.XML_ozone.om.decommissioned.nodes.cluster1
  value: ""
{{- range $tempId := $allOmNodes }}
- name: {{ printf "OZONE-SITE.XML_ozone.om.address.cluster1.%s" $tempId }}
  value: {{ printf "%s.%s-om-headless.%s.svc.cluster.local" $tempId $.Release.Name $.Release.Namespace }}
{{- end }}
{{ $allOmNodes = append $allOmNodes "om-leader-transfer"}}
- name: OZONE-SITE.XML_ozone.om.nodes.cluster1
  value: {{ $allOmNodes | join "," }}
- name: "OZONE-SITE.XML_ozone.om.address.cluster1.om-leader-transfer"
  value: localhost
{{- end }}