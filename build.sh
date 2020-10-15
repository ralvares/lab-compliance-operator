podman build -t quay.io/ralvares/lab-compliance-operator:test -f ./Dockerfile.workshop
echo podman run --rm -p 10080:10080 quay.io/ralvares/lab-compliance-operator:test
