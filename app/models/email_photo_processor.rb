class EmailPhotoProcessor

  def initialize(email)
    @email = email
  end

  def process
    from_tokens = @email.to.collect { |e| e[:token] }
    group = Group.where(email: from_tokens).first!
    @email.attachments.each do |a|
      group.photos.create!(picture: a, subject: @email.subject, body: @email.body)
    end
  end

end
