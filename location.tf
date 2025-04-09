
resource "aws_location_tracker" "tracker" {
  tracker_name = "explore.tracker"
  description  = "Tracker for SwiftHaul deliveries"
}

resource "aws_location_route_calculator" "route_calc" {
  calculator_name = "ParcelDeliveryCalculator"
  data_source     = "Here"
  description     = "Route calculator for delivery optimization"
}

resource "aws_location_place_index" "place_index" {
  index_name  = "AddressSearch"
  data_source = "Here"
  description = "Place index for geocoding and address search"
}

resource "aws_location_map" "delivery_map" {
  map_name    = "DeliveryRouteMap"
  description = "Map for visualizing delivery routes"
  configuration {
    style = "VectorHereExplore"
  }
}
