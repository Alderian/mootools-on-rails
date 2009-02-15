module ActionView
  module Helpers
    module MootoolsSortableHelper
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



          js = "var rows = $('#{table_dom_id}').getElements('tbody');"
          js << "rows.getElements('tr').each(function(el){el.addClass('draggable');});"
          js << "var sortable = new Sortables(rows,{
          snap: #{sortable_options[:snap]},
          revert: {duration:#{sortable_options[:revert][:duration]}},
          onComplete: function(el) {
            changes='_method=put&order='+sortable.serialize(0);
            var myRequest = new Request({url: '#{sortable_options[:url]}',method: 'post'}).send(changes);
            el.highlight('#{sortable_options[:higlight_color]}');
          	}}
          );"
          javascript_tag(dom_ready(js))
        else
          ""
        end
      end
    end
  end
end