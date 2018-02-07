module ApplicationHelper
  def show_avatar(user, size = 100)
    id = Digest::MD5.hexdigest(user.email.downcase)
    path = "https://secure.gravatar.com/avatar/#{id}?s=#{size}&d=mm"
    image_tag(path, alt: user.email, class: "avatar")
  end
  
  def extract_name(user)
    # name = user.email.split(/@/)[0]
    name = user.email.slice(/\w+(?=@)/)
    truncate(name, length: 15)
  end
  
  def current_user?(user)
    self == current_user
  end

end
