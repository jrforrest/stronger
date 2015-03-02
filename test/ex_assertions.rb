# A couple of assertions for testing exceptions.
#
# These already exist in MiniTest but I don't like the way they work.
module ExAssertions
  private

  def refute_ex_raised(ex, lam, message = nil)
    refute(raised?(ex, &lam), message)
  end

  def assert_ex_raised(ex, lam, message = nil)
    assert(raised?(ex, &lam), message)
  end

  def raised?(ex)
    yield
    return false
  rescue ex => e
    return true
  end
end
