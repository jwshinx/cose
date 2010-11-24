# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def with_tooltip(tool_tip_text, options={}, &block)
    content = capture(&block)
    opts = tag_options(options[:html]);
    #uid = "tooltipsjs_#{get_uid}"
    concat("<span class='stylesize13' #{opts}>")
    concat(content)
    concat("<div style='display:none'><span>#{tool_tip_text}</span></div>")
    concat("</span>")
  end

  def help(condition, &block)
    uniqid = rand; concat( link_to_function("+/- help") do |page|
      page["help_#{uniqid}"].toggle
      page.visual_effect :highlight, "help_#{uniqid}"
    end + content_tag(:div,:class=>"help",:id=>"help_#{uniqid}", :style=>"display:none") do
      yield
    end )
  end
  def ring_size(condition, attributes = {}, &block)
    content = capture(&block)
    unless condition
      attributes["style"] = "display: none"
    else
    end
    content_tag("div", attributes, &block)
=begin
    unless condition
      concat("<div style='display: none;'>")
      concat(content)
      concat("<input type='hidden' name='on0' value='0'>")
      concat("</div>")
    else
      concat("<div>")
      concat(content)
      concat("</div>")
    end
=end

  end
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end
  def hidden_hometext_unless(condition, attributes = {}, &block)
    unless condition
      attributes["style"] = "display: none"
    end
    #attributes["id"] = "side-for-btm-links-div"
    content_tag("div", attributes, &block)
  end
  def hidden_div_unless(condition, attributes = {}, &block)
    unless condition
      attributes["style"] = "display: none"
    end
    if(attributes[:alt] == 'custom')
      attributes["id"] = "customtext-div"
    elsif(attributes[:alt] == 'earrings')
      attributes["id"] = "earringstext-div"
    elsif(attributes[:alt] == 'necklaces')
      attributes["id"] = "necklacestext-div"
    elsif(attributes[:alt] == 'rings')
      attributes["id"] = "ringstext-div"
    else
      attributes["id"] = "othertext-div"
    end
    content_tag("div", attributes, &block)
  end
  def hidden_categorytext_div_unless(condition, attributes = {}, &block)
    unless condition
      attributes["style"] = "display: none"
    end 
    if(attributes[:pagetype] == 'earrings' ||
       attributes[:pagetype] == 'necklaces' ||
       attributes[:pagetype] == 'rings')
      attributes["id"] = "categorytext-div"
    elsif(attributes[:pagetype] == 'custom')
      attributes["id"] = "customtext-div"
    else
      attributes["id"] = "elseyyycategorytext-div"
    end
    content_tag("div", attributes, &block)
  end
  def hidden_productdesc_div_unless(condition, attributes = {}, &block)
    unless condition
      attributes["style"] = "display: none"
    end
    attributes["id"] = "productdesc-div"
    content_tag("div", attributes, &block)
  end
  def wide_menu_unless(condition, attributes = {}, &block)
    unless condition
      attributes["id"] = "menu"
    else
      attributes["id"] = "menu-compact"
    end
    content_tag("div", attributes, &block)
  end
  def wide_menu_btm_unless(condition, attributes = {}, &block)
    unless condition
      attributes["id"] = "menu-btm"
    else
      attributes["id"] = "menu-btm-compact"
    end
    content_tag("div", attributes, &block)
  end
end
