require 'matrix_formatter'

class MatrixFormatter::Formatters::HTMLFormatter < MatrixFormatter::Formatters::MarkdownFormatter
  def start_dump
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)

    @output.puts header
    @output.puts renderer.render(markdown)
    @output.puts footer
  end

  def header
    """
    <html>
    <head>
    <style type=\"text/css\">
      td {
          padding: 7px 10px;
          vertical-align: top;
          text-align: left;
          border: 1px solid #ddd;
      }
      .passed {
        color: green;
      }
      .failed {
        color: red;
      }
      .pending {
        color: blue;
      }
    </style>
    </head>
    <body>
    """
  end

  def footer
    """
    </body>
    <script type=\"text/javascript\">
      var table = document.getElementsByTagName('table')[0];
      var tbody = table.getElementsByTagName('tbody')[0];
      var cells = tbody.getElementsByTagName('td');

      for (var i=0, len=cells.length; i<len; i++){
          if (cells[i].innerText === 'failed'){
              cells[i].className = 'failed';
          }
          else if (cells[i].innerText === 'passed'){
              cells[i].className = 'passed';
          }
          else if (cells[i].innerText === 'pending'){
              cells[i].className = 'pending';
          }
      }
    </script>
    </html>
    """
  end
end
