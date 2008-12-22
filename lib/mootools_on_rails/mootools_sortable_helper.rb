module ActionView
  module Helpers
    module MootoolsSortableHelper

# sortable_element('sortable_list', { :url => {:action => :update_positions} })

      # sortable_element(container, options)
      #
      # NOT a full implimentation
      def sortable_element(container, sortable_options = {})
        if container.any?
          
          sortable_options.merge!(
            :snap=>4,
            :revert=>{:duration=>100},
            :higlight_color=>'#F3F865',
            :clone=> 'true',
            :constrain => 'true'
            )   
            
            sortable_options[:url] = url_for(sortable_options[:url]) if sortable_options[:url].is_a?(Hash)
          
            js = "var sortable = new Sortables('#{container}',{
            snap: #{sortable_options[:snap]},
            revert: {duration:#{sortable_options[:revert][:duration]}},
            clone: #{sortable_options[:clone]},
            constrain: #{sortable_options[:constrain]},
            onComplete: function(el) {
              changes='_method=put&'+sortable.serialize(false, function(element, index){
                  return '#{container}[]='+element.getProperty('id').replace('item_','');
              }).join('&');
              
              changes += '&#{request_forgery_protection_token}=' + encodeURIComponent(\'#{escape_javascript(form_authenticity_token)}\');
              
              var myRequest = new Request({url: '#{sortable_options[:url]}',method: 'post'}).send(changes);
              el.highlight('#{sortable_options[:higlight_color]}');
            	}}
            );\n"
          javascript_tag(dom_ready(js))
        else
          ""
        end
      end
      
      
      #
      # sortable_table(@collection,table_dom_id)
      #
      # allows to convert an standar table to sortable
      #
      def sortable_table(collection,table_dom_id,sortable_options={})
        collection = instance_variable_get("@#{collection}") if collection.kind_of?(Symbol)
        
        if collection.any?
          sortable_options.merge!(:url=>"/sortable/#{collection.first.class.name.underscore}",
            :snap=>10,
            :revert=>{:duration=>1000},
            :higlight_color=>'#F3F865',
            :clone=> "true"
            )



          js = "var rows = $('#{table_dom_id}').getElements('tbody');\n"
          js << "rows.getElements('tr').each(function(el){el.addClass('draggable');});\n"
          js << "var sortable = new Sortables(rows,{
          snap: #{sortable_options[:snap]},
          revert: {duration:#{sortable_options[:revert][:duration]}},
          onComplete: function(el) {
            changes='_method=put&order='+sortable.serialize(0);
            var myRequest = new Request({url: '#{sortable_options[:url]}',method: 'post'}).send(changes);
            el.highlight('#{sortable_options[:higlight_color]}');
          	}}
          );\n"
          javascript_tag(dom_ready(js))
        else
          ""
        end
      end
    end
  end
end