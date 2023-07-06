# Install

Add ingress-nginx in the nginx-ingress namesapce
```bash
cd ingress-nginx
kubectl create ns ingress-nginx
helm dependency update
helm install ingress-nginx . -f values.yaml -n ingress-nginx
```

For each repo : 

```bash
cd <name>
helm dependency update
helm install <name> . -f values.yaml
```
