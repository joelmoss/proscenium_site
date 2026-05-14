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

      assert_equal '<h1>1</h1><h2>2</h2><h3>3</h3><h4>4</h4><h5>5</h5><h6>6</h6>', output
    end

    it 'supports ordered lists' do
      output = md <<~MD
        1. One
        2. Two
        3. Three
      MD

      assert_equal '<ol><li>One</li><li>Two</li><li>Three</li></ol>', output
    end

    it 'supports unordered lists' do
      output = md <<~MD
        - One
        - Two
        - Three
      MD

      assert_equal '<ul><li>One</li><li>Two</li><li>Three</li></ul>', output
    end

    it 'supports inline code' do
      output = md 'Some `code` here'
      assert_equal '<p>Some <code>code</code> here</p>', output
    end

    it 'supports block code' do
      output = md <<~MD
        ```ruby
        def foo
        	bar
        end
        ```
      MD

      assert_equal %(<pre><code class="language-ruby">def foo\n\tbar\nend\n</code></pre>), output
    end

    it 'supports paragraphs' do
      output = md "A\n\nB"
      assert_equal '<p>A</p><p>B</p>', output
    end

    it 'supports links' do
      output = md "[Hello](world 'title')"
      assert_equal %(<p><a href="world" title="title">Hello</a></p>), output
    end

    it 'supports emphasis' do
      output = md '*Hello*'
      assert_equal '<p><em>Hello</em></p>', output
    end

    it 'supports strong' do
      output = md '**Hello**'
      assert_equal '<p><strong>Hello</strong></p>', output
    end

    it 'supports blockquotes' do
      output = md '> Hello'
      assert_equal '<blockquote><p>Hello</p></blockquote>', output
    end

    it 'supports horizontal rules' do
      output = md '---'
      assert_equal '<hr>', output
    end

    it 'supports images' do
      output = md "![alt](src 'title')"
      assert_equal %(<p><img src="src" alt="alt" title="title"></p>), output
    end

    it 'supports softbreaks in content as spaces' do
      output = md <<~MD
        One
        Two

        Three
      MD

      assert_equal '<p>One Two</p><p>Three</p>', output
    end

    def md(content)
      Phlex::Markdown.new(content).call
    end
  end
end
