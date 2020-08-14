module github.com/giantswarm/test-infra/log

go 1.14

require (
	github.com/pkg/errors v0.9.1
	github.com/tektoncd/cli v0.11.0
	github.com/tektoncd/pipeline v0.15.2
	k8s.io/api v0.18.7-rc.0
	k8s.io/apimachinery v0.18.7-rc.0
	knative.dev/pkg v0.0.0-20200814174506-3cc3a54f7117
)

replace k8s.io/api => k8s.io/api v0.17.7
replace k8s.io/apimachinery => k8s.io/apimachinery v0.17.7
replace k8s.io/client-go => k8s.io/client-go v0.17.7
