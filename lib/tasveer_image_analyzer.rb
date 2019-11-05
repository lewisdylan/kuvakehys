class TasveerImageAnalyzer < ActiveStorage::Analyzer

  def self.accept?(blob)
    blob.image?
  end

  def metadata
    {}.tap do |m|
      m[:label_names] = ImageRekognition.new(self.blob.key).label_names
      # TODO: don't do that here in the analyze metadata getter method
      self.blob.attachments.each do |a|
        a.record.tag_names.push(*m[:label_names])
        a.record.save
      end
      read_image do |image|
        if rotated_image?(image)
          m.merge!({ width: image.height, height: image.width })
        else
          m.merge!({ width: image.width, height: image.height })
        end
      end
    end
  rescue LoadError
    logger.info "Skipping image analysis because the mini_magick gem isn't installed"
    {}
  end

  private
    def read_image
      download_blob_to_tempfile do |file|
        require "mini_magick"
        yield MiniMagick::Image.new(file.path)
      end
    end

    def rotated_image?(image)
      %w[ RightTop LeftBottom ].include?(image["%[orientation]"])
    end
end
