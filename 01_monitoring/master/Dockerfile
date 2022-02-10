FROM sensu/sensu:latest

# Environment variables
ENV SENSU_BACKEND_CLUSTER_ADMIN_USERNAME="admin"
ENV SENSU_BACKEND_CLUSTER_ADMIN_PASSWORD="password1@#"

# 
EXPOSE 3000
# 
EXPOSE 8080
# 
EXPOSE 8081

CMD [ "sensu-backend start --state-dir /var/lib/sensu/sensu-backend --log-level debug" ]
