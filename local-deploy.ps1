
& minikube image build . --tag local/gha-talk:current
# $LastExitCode is pointless here - build failures still exit with 0

& kubectl get deployment/gha-talk | Out-Null
if ($LastExitCode -eq 0) {
    & kubectl delete deployment/gha-talk
    if ($LastExitCode -gt 0) { throw "kubectl delete failed with error $LastExitCode" }
}

& kubectl create deployment gha-talk --image=local/gha-talk:current
if ($LastExitCode -gt 0) { throw "kubectl create deployment failed with error $LastExitCode" }
& kubectl wait deployment gha-talk --for condition=Available=True --timeout=90s
if ($LastExitCode -gt 0) { throw "kubectl wait deployment failed with error $LastExitCode" }

& kubectl get service/gha-talk | Out-Null
if ($LastExitCode -gt 0) {
    & kubectl expose deployment gha-talk --type=NodePort --port=8080 --target-port=8080 --name gha-talk
    if ($LastExitCode -gt 0) { throw "kubectl expose deployment failed with error $LastExitCode" }
}
