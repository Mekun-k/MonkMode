module DeviseHelper
  def bootstrap_alert(key)
    case key
    when "alert"
      "warning"
    when "notice"
      "success"
    when "error"
      "danger"
    end
  end

  def devise_error_messages!
    return "" if resource.errors.empty?

    resource.errors.full_messages.map do |errmsg|
      <<-EOF
      <div class="alert alert-error alert-dismissible fade show mb-0">
        #{errmsg}
      </div>
      EOF
    end.join
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
