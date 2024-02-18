module ApplicationHelper
  def sidebar_link_item(name, path)
    class_name = 'channel'
    class_name << ' active' if current_page?(path)

    content_tag :li, class:class_name do
      link_to name, path, class: 'channel_name'
    end
  end

  def default_meta_tags
    {
      site: 'MONKMODE',
      title: 'MONKMODEを取り入れて自分の夢・目標を叶えて人生を切り開こう',
      reverse: true,
      charset: 'utf-8',
      description: 'MONKMODEとは,自分の足を引っ張る余計なものを徹底的に排除し、結果を出すための生活を徹底するライフスタイルのこと',
      keywords: 'MONKMODE,モンクモード,自己規律,瞑想,自分磨き,男磨き,ジョージ',
      canonical: request.original_url,
      separator: '|'
    }
  end
end
