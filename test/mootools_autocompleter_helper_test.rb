require File.dirname(__FILE__) + '/test_helper'

class MootoolsHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::MootoolsHelper
  include ActionView::Helpers::MootoolsAutocompleterHelper



  
  def test_autocomlete_field_tag
    actual = autocomplete_field_tag :customer,:name, "invoice[customer_name]","Hello!"
    expected = %(<script type="text/javascript">\n//<![CDATA[\nwindow.addEvent('domready', function() {new Autocompleter.Ajax.Json('autocomplete_for_customer_name', '/autocompleter/customer/name', '{}');});\n//]]>\n</script><input id="autocomplete_for_customer_name" name="invoice[customer_name]" type="text" value="Hello!" />)
    assert_dom_equal expected, actual
  end
end