# frozen_string_literal: true

require 'phlex/markdown'

class Phlex::MarkdownTest < ActiveSupport::TestCase
  describe 'markdown' do
    it 'supports multiple headings' do
      output = md <<~MD
        # 1
        ## 2
        ### 3
        #### 4
        ##### 5
        ###### 6
      MD

      assert_equal output, '<h1>1</h1><h2>2</h2><h3>3</h3><h4>4</h4><h5>5</h5><h6>6</h6>'
    end

    it 'supports ordered lists' do
      output = md <<~MD
        1. One
        2. Two
        3. Three
      MD

      assert_equal output, '<ol><li>One</li><li>Two</li><li>Three</li></ol>'
    end

    it 'supports unordered lists' do
      output = md <<~MD
        - One
        - Two
        - Three
      MD

      assert_equal output, '<ul><li>One</li><li>Two</li><li>Three</li></ul>'
    end

    it 'supports inline code' do
      output = md 'Some `code` here'
      assert_equal output, '<p>Some <code>code</code> here</p>'
    end

    it 'supports block code' do
      output = md <<~MD
        ```ruby
        def foo
        	bar
        end
        ```
      MD

      assert_equal output, %(<pre><code class="language-ruby">def foo\n\tbar\nend\n</code></pre>)
    end

    it 'supports paragraphs' do
      output = md "A\n\nB"
      assert_equal output, '<p>A</p><p>B</p>'
    end

    it 'supports links' do
      output = md "[Hello](world 'title')"
      assert_equal output, %(<p><a href="world" title="title">Hello</a></p>)
    end

    it 'supports emphasis' do
      output = md '*Hello*'
      assert_equal output, '<p><em>Hello</em></p>'
    end

    it 'supports strong' do
      output = md '**Hello**'
      assert_equal output, '<p><strong>Hello</strong></p>'
    end

    it 'supports blockquotes' do
      output = md '> Hello'
      assert_equal output, '<blockquote><p>Hello</p></blockquote>'
    end

    it 'supports horizontal rules' do
      output = md '---'
      assert_equal output, '<hr>'
    end

    it 'supports images' do
      output = md "![alt](src 'title')"
      assert_equal output, %(<p><img src="src" alt="alt" title="title"></p>)
    end

    it 'supports softbreaks in content as spaces' do
      output = md <<~MD
        One
        Two

        Three
      MD

      assert_equal output, '<p>One Two</p><p>Three</p>'
    end

    def md(content)
      Phlex::Markdown.new(content).call
    end
  end
end
