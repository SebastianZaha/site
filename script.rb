#!/usr/bin/env ruby

TXT = "#{ENV['HOME']}/Dropbox/txt/"
PAGES = %w(
  site/about.md
  site/articles_old/cplay_scrobbler.html
  site/articles_old/dreamhost.html
  site/articles_old/image_upload.html
  site/articles_old/sradio.html

  travel/vienna_parking_ro.md.txt
)

ROOT   = File.dirname(__FILE__)
HEADER = File.read(ROOT + '/header.html')
FOOTER = File.read(ROOT + '/footer.html')

require 'redcarpet'


def render_page(path)
  content = File.read(path)
  if path.match(/.md$/) || path.match(/.md.txt$/)
    content = render_markdown(content)
  end
  content
end

def render_markdown(str)
  renderer = Redcarpet::Render::HTML.new(hard_wrap: false)
  markdown = Redcarpet::Markdown.new(
      renderer,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      autolink: false,
      highlight: true)
  markdown.render(str)
end

def generate
  PAGES.each do |p|
    b = p.split('/').last.split('.').first
    out = "#{ROOT}/public/#{b}.html"

    File.open(out, 'w') do |f|
      f.puts HEADER
      f.puts render_page("#{TXT}/#{p}")
      f.puts FOOTER
    end
  end
end

def deploy
  system('rsync --archive --verbose --compress --delete public/ dh:~/sebi.tla.ro/')
end

if ARGV[0] == 'deploy'
  deploy
else
  generate
end
