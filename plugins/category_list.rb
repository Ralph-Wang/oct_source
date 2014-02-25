module Jekyll
    class CategoryListTag < Liquid::Tag
        def render(context)
            html = ""
            categories = context.registers[:site].categories.keys
            categories.sort.each do |category|
                posts_in_category = context.registers[:site].categories[category].size
                category_dir = context.registers[:site].config['category_dir']
                category_url = File.join(category_dir, category.to_url)
                html << "<a class='list-group-item' href='#{category_url}/'>#{category} <span class='badge'>#{posts_in_category}</span></a>\n"
            end
            html
        end
    end
end

Liquid::Template.register_tag('category_list', Jekyll::CategoryListTag)
