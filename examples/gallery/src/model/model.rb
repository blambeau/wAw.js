class Model < WawJS::Brick
  
  def initialize(igallery)
    super
    @igallery = igallery
  end
  
  def albums(*args)
    @igallery.albums
  end
  
  def images(albid, *args)
    @igallery.all_images(albid)
  end
  
  get '/:what' do
    content_type :json
    send(params[:what], params[:albid]).to_json
  end

end # class Model