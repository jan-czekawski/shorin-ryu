module ApplicationHelper
  def show_avatar(user, size = 100)
    unless user.image.blank?
      return image_tag(user.image.url,
                       alt: user.email,
                       size: 100,
                       class: "avatar")
    end
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
    user == current_user
  end

  def owner_or_admin?(user, resource)
    return false unless user_signed_in?
    user.admin? || resource.user_id == user._id
  end

  def show_flash(arg)
    arg.gsub(/\n/, '')
       .gsub(/\"/, '\'')
       .html_safe
    # arg.delete(/\n/)
    #   .tr(/\"/, '\'')
    #   .html_safe
  end
end
