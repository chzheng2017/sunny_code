#!/bin/bash
for i in {1..20}
do
        echo "#Run Post tunnel API call to create a tunnel"
        /usr/local/bin/kubectl exec -it tartarus-hermes-server-dpl-bbc5bd646-5hwh8 -n tartarus -- sh -c "curl --location --request POST http://tartarus-hermes-server-svc.tartarus:8000/tunnel -d '{\"tunnelOwner\":\"apollo\", \"target_id\": \"SSH\",\"agent\": \"pm4579_test_node\"}'"
        echo " "; echo "#Check svc port before 2mins" 
        /usr/local/bin/kubectl get svc -n tartarus | grep tunnel
        echo "#sleep 120s" 
        sleep 120
        echo "#Check svc port after 2mins " 
        /usr/local/bin/kubectl get svc -n tartarus | grep tunnel
        echo " "
done
