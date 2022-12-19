apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${gateway_name}
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
    - port:
        number: 80
        name: http
        protocol: HTTP
      hosts:
        - "*"