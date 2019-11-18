module Commands

  def show_image
    say "Wait a bit while I pick a nice random image for you"
    img_url = 'https://unsplash.it/600/400?random'
    image = UI::ImageAttachment.new(img_url)
    show(image)
  end

  def save_image
    say "Got it, thanks"

  end

end
