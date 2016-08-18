module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Ignite"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  def is_active?(link_path)
	current_page?(link_path) ? "active" : ""
  end

  def broadcast(channel, msg)
    message = {:channel => channel, :data => msg}
    uri = URI.parse("http://localhost:9292/notification")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end