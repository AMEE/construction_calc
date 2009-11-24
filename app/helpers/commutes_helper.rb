module CommutesHelper
  def options_for_commute_type_select
    Commute::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort{|a,b| a[0] <=> b[0]}
  end
end