HighVoltage.configure do |config|
  #  render the page from app/views/pages/home.html.erb when the '/' route of the site is accessed.
  # config.home_page = 'home'
  # remove the directory pages from the URL path and serve up routes from the root of the domain path:
  config.route_drawer = HighVoltage::RouteDrawers::Root
end