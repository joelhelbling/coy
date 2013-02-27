require 'stringio'

module IOHelpers

  def output_from
    $stdout = $stderr = fake_io
    yield
    fake_io.string
  ensure
    $stdout = STDOUT; $stderr = STDERR
  end

  def user_types(input, &block)
    $stdin = StringIO.new input
    output_from &block
  ensure
    $stdin = STDIN
  end

  def stdout_from(&block)
    output_from &block
  end

  def stderr_from(&block)
    output_from &block
  end

  def fake_io
    @fake_io ||= StringIO.new
  end

end
