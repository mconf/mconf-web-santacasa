module AttachmentsHelper
  def table_actions(attachment)
    html = ""
    html << link_to(image_tag("icons/cancel.png", :alt => t('delete'),:class=>"icon"), space_attachment_path(@space,attachment, :version => attachment.version), {:method => :delete, :title => t('attachment.delete'), :confirm => t('delete.confirm', :element => t('attachment.one'))}) if attachment.authorize?(:delete, :to => current_user)
    html << link_to("NV")
    html << link_to(image_tag("icons/comment.png", :alt => t('post.one'),:class=>"icon"), space_post_path(@space,attachment.post)) if attachment.post.present?
    html << link_to(image_tag("icons/date.png", :alt => t('date.one'),:class=>"icon"), space_event_path(@space,attachment.event)) if attachment.event.present?
    html
  end
  
  def sortable_header(title,column)
    html = title
    html << " "
    html << link_to("DESC", path_for_attachments({:order => column, :direction => 'desc'}), :class => "sortable table_params desc#{"_active" if (params[:direction] == 'desc' and column == params[:order]) }" )
    html << " "
    html << link_to("ASC", path_for_attachments({:order => column, :direction => 'asc'}), :class => "sortable table_params desc#{"_active" if (params[:direction] == 'asc' and column == params[:order]) }" )
    html  
  end
  
  def version_attachment(attachments)
    
    versioned_attachment_ids = expand_versions_to_array
    
    att_version_array = attachments.clone

    if versioned_attachment_ids.present?
      versioned_attachment_ids.each do |id|
        if attachments.map(&:id).include?(id.to_i)
          attachment = Attachment.find(id.to_i)
          index = att_version_array.index(attachment)
          att_version_array[index] = attachment.versions.reverse
          att_version_array.flatten!
        end
      end
    end

    att_version_array 
  end
  
  def path_for_attachments(p={})
    direction = p[:direction].present? ? p[:direction] : params[:direction]
    order = p[:order].present? ? p[:order] : params[:order]
    expand_versions=expand_versions_to_array - [p[:not_expanded]] + [p[:expanded]]
    tags = tags_to_array - [p[:rm_tag]] + [p[:add_tag]]
    space_attachments_path(@space,:direction => direction, :order => order, :expand_versions => expand_versions.uniq.join(","), :tags => tags.uniq.join(","))
  end
  
  def options_for_fcbkcomplete(collection,value,text,selected=nil)
    html=""
    collection.each do |t|
      html << %(<option value="#{t.send(value)}"#{"class=selected" if selected.include?(t)}>#{t.send(text)}</option>)
    end
    html
  end
  
  private
  
  def expand_versions_to_array
    params[:expand_versions].present? ? params[:expand_versions].split(",").map(&:to_i) : Array.new
  end
  
  def tags_to_array
    params[:tags].present? ? params[:tags].split(",").map(&:to_i) : Array.new
  end
end
