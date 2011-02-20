require File.expand_path('../../server/lib/igallery', __FILE__)
require File.expand_path('../model/model', __FILE__)
require File.expand_path('../see/see', __FILE__)
class Gallery < WawJS::Brick
  
  NO_CACHE_HEADERS = {'Cache-control' => "no-store, no-cache, must-revalidate", 
                      'Pragma'        => "no-cache", 
                      'Expires'       => "Thu, 01 Dec 1994 16:00:00 GMT"}

  def initialize(igallery = nil)
    super
    @igallery = igallery
  end
  
  set :public, File.expand_path("../public", __FILE__)
  
  get '/' do
    send_file File.expand_path('../public/index.html', __FILE__)
  end
  
  get '/image/:album/:image' do
    headers NO_CACHE_HEADERS
    image = @igallery.image(params[:album], params[:image])
    send_file @igallery._(image[:path])
  end
  
  get '/thumb/:album/:image' do
    headers NO_CACHE_HEADERS
    image = @igallery.image(params[:album], params[:image])
    send_file @igallery._(image[:thumb])
  end

end