formattings do   
  
  format 'b' do
    at_slide { bold }
  end
  
  format 'r' do 
    at_slide { bold; color 0,0,255 }
  end
  
  format 'B' do 
    from_slide { bold }
  end
  
  format 'R' do 
    from_slide { bold; color 0,0,255 }
  end
  
  toggle_formats '>', '<' do
    on do
	  at_slide { bold; color 0,0,0 }
    end
    off do
      from_slide { background_color }
    end
  end

  toggle_formats '+', '-' do
    on do
      from_slide { undelete }
	    at_slide { bold }
	  end
	  off do
      from_slide { delete }
	  end
  end  
  
end