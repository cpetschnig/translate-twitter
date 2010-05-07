module ShowcaseHelper
  def user_account_li(user = :show_all, active = false)
    name_1, name_2, screen_name, img_url, img_alt = if user == :show_all
      ['Japanese Rubyists', '', '', 'images/ruby.png', 'Show all']
    else
      [user.username, user.real_name, user.username, user.image_url, %{http://twitter.com/#{user.username}}]
    end
    user_account_list_item(name_1, name_2, screen_name, img_url, img_alt, active)
  end

  private
  def user_account_list_item_(name_1, name_2, screen_name, img_url, img_alt, active)
    content = %{<img src="#{img_url}" alt="#{img_alt}" class="tw_normal" />
<span class="screen_name">#{name_1}</span><br />
#{name_2}}
    if active
      %{<li class="active"><div>
#{content}
</div></li>
}
    else
      %{<li><a href="/#{screen_name}">
#{content}
</a></li>
}
    end.html_safe
  end

  def user_account_list_item(name_1, name_2, screen_name, img_url, img_alt, active)
    %{<li#{' class="active"' if active}>
      <a href="/#{screen_name}" class="name">
        <span class="screen_name">#{name_1}</span><br />
        #{name_2}
      </a>
      <a href="/#{screen_name}" class="thumb">
        <img src="#{img_url}" alt="#{img_alt}" title="#{screen_name}" class="tw_normal" />
      </a>
    </li>}.html_safe
  end
end
