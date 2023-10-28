module ScaffoldHelper
  def index_lnk_to(name, path = nil, model: nil, **, &)
    if path.nil?
      path = name
      name = nil
    end
    model = path if model.nil?
    name = t("#{i18n_key_from_model(model)}.index.title") if name.nil?

    return unless policy_from_model(model).index?

    if path.nil?
      route_key = model.model_name.route_key
      path = send("#{route_key}_path")
    end

    lnk_to(name, path, **, &)
  end

  def back_to_index_lnk_to(name, path = nil, model: nil, **, &)
    if path.nil?
      path = name
      name = t("back_to_index")
    end
    model = path if model.nil?

    return unless policy_from_model(model).index?

    path = model if path.nil?
    index_lnk_to(name, path, color: :secondary, **, &)
  end

  def show_lnk_to(name, path = nil, record: nil, **, &)
    if path.nil?
      path = name
      name = t("detail")
    end
    record = path if record.nil?

    return unless policy(record).show?

    path = record if path.nil?
    lnk_to(name, path, **, &)
  end

  def new_lnk_to(name, path = nil, model: nil, **, &)
    if path.nil?
      path = name
      name = nil
    end
    model = path if model.nil?
    name = t("#{i18n_key_from_model(model)}.new.title") if name.nil?

    return unless policy_from_model(model).new?

    if path.nil?
      route_key = model.model_name.singular_route_key
      path = send("new_#{route_key}_path")
    end

    lnk_to(name, path, type: :link, **, &)
  end

  def edit_lnk_to(name, path = nil, record: nil, **, &)
    if path.nil?
      path = name
      name = t("edit")
    end
    record = path if record.nil?

    return unless policy(record).edit?

    path = [:edit, record] if path.nil?
    lnk_to(name, path, **, &)
  end

  def destroy_btn_to(name, path = nil, record: nil, **, &)
    if path.nil?
      path = name
      name = t("destroy")
    end
    record = path if record.nil?

    return unless policy(record).destroy?

    path = record if path.nil?
    btn_to(
      name,
      path,
      method: :delete,
      form: { data: { turbo_confirm: t("destroy_confirm") } },
      color: :danger,
      **,
      &
    )
  end

  private

  def i18n_key_from_model(model)
    model_name = model.model_name
    [
      model_name.i18n_key.to_s.split("/")[0..-2].join("."),
      model_name.element.pluralize
    ].select(&:present?).join(".")
  end

  def policy_from_model(model)
    policy_token = model.model_name.singular.to_sym
    policy(policy_token)
  end
end