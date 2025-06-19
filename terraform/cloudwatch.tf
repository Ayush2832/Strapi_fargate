resource "aws_cloudwatch_log_group" "strapi_logs" {
  name              = "/ecs/strapi"
  retention_in_days = 7

  tags = {
    Name = "Strapi-loggroup"
  }
}

resource "aws_cloudwatch_dashboard" "dashboards" {
  dashboard_name = "Strapi-ecs-dashboards"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 10,
        height = 7,

        properties = {
          title = "CPU utilization"
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "Cluster Name",
              var.strapi_cluster,
              "ServiceName",
              var.strapi_service
            ]
          ]
          period = 30, # we are getting data in each 30 sec
          stat = "Average",
          region = var.aws_region

        },
        
      },
      {
        type = "metric"
        x = 0,
        y = 0,
        width = 10,
        height = 7,

        properties = {
          title = "Memory Utilization",
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.strapi_cluster,
              "ServiceName",
              var.strapi_service
            ]
          ]
          period = 30,
          stat = "Average"
          region = var.aws_region
        }
      },
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 10,
        height = 7,
        properties={
          title = "Network IN/OUT"
          metrics = [
            [
              "AWS/ECS",
              "NetworkBytesIn",
              "ClusterName", var.strapi_cluster,
              "ServiceName", var.strapi_service
            ],
            [
              ".","NetworkBytesOut",".",".",".","."
            ]
          ]
          period = 30,
          stat = "Average"
          region = var.aws_region
        }
      }
    ]
  })
  
}