
module ContentPathIncludesArchive

  def generate_path_slug
    if self.path and self.path.parent
      slug = "#{self.path.parent.slug}/"
    else
      if archive
        slug = "/#{archive.slug}/"
      else
        slug = "/"
      end
    end

    slug += sluggerize(title)    
  end  
end
