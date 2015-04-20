Pod::Spec.new do |s|
  s.name         = "UITableView+NSFetchedResultsController"
  s.version      = "1.0"
  s.summary      = "NSFRC category for UITV that collects the data source changes and executes them in proper order, while avoiding lots of pitfalls of the usual sample code."
  s.homepage     = "https://github.com/radianttap/UITableView+NSFetchedResultsController"
  s.license      = 'MIT'
  s.author       = { "Aleksandar Vacić" => "radianttap.com" }
  s.source       = { :git => "https://github.com/radianttap/UITableView-NSFetchedResultsController.git", :tag => "#{s.version}" }
  s.platform     = :ios, '7.0'
  s.source_files = 'UITableView+NSFetchedResultsController.{h,m}'
  s.frameworks   = 'CoreData'
  s.requires_arc = true
end
