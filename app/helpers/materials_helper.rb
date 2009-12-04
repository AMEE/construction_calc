module MaterialsHelper
  def options_for_material_type_select
    Material::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort{|a,b| a[0] <=> b[0]}
  end
end