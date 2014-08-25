#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module WorkPackagesFilterHelper
  # General
  def project_property_path(project, property, property_id)
    query = {
      f: [
        filter_object(property, "=", property_id),
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query)
  end


  # Links for my page
  def work_packages_assigned_to_me_path
    query = {
      f: [ filter_object("assigned_to_id", "=", "me") ],
      t: 'priority:desc,updated_at:desc'
    }
    work_packages_with_query_path(query)
  end

  def work_packages_reported_by_me_path
    query = {
      f: [ filter_object("author_id", "=", "me") ],
      t: 'updated_at:desc'
    }
    work_packages_with_query_path(query)
  end

  def work_packages_responsible_for_path
    query = {
      f: [ filter_object("responsible_id", "=", "me") ],
      t: 'priority:desc,updated_at:desc'
    }
    work_packages_with_query_path(query)
  end

  def work_packages_watched_path
    query = {
      f: [ filter_object("watcher_id", "=", "me") ],
      t: 'updated_at:desc'
    }
    work_packages_with_query_path(query)
  end

  # Links for project overview
  def project_work_packages_closed_version_path(version)
    query = {
      f: [
           filter_object("status_id", "c"),
           filter_object("fixed_version_id", "=", version.id)
         ]
    }
    project_work_packages_with_query_path(version.project, query)
  end

  def project_work_packages_open_version_path(version)
    query = {
      f: [
           filter_object("status_id", "o"),
           filter_object("fixed_version_id", "=", version.id)
         ]
    }
    project_work_packages_with_query_path(version.project, query)
  end

  # Links for reports
  def project_report_property_path(project, property, property_id)
    query = {
      f: [
        filter_object("subproject_id", "!*"),
        filter_object(property, "=", property_id),
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query)
  end

  def project_report_property_status_path(project, status_id, property, property_id)
    query = {
      f: [
        filter_object("status_id", "=", status_id),
        filter_object("subproject_id", "!*"),
        filter_object(property, "=", property_id),
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query)
  end

  def project_report_property_open_path(project, property, property_id)
    query = {
      f: [
        filter_object("status_id", "o"),
        filter_object("subproject_id", "!*"),
        filter_object(property, "=", property_id),
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query)
  end

  def project_report_property_closed_path(project, property, property_id)
    query = {
      f: [
        filter_object("status_id", "c"),
        filter_object("subproject_id", "!*"),
        filter_object(property, "=", property_id),
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query)
  end

  def project_report_property_any_status_path(project, property, property_id)
    query = {
      f: [
        filter_object("status_id", "*"),
        filter_object("subproject_id", "!*"),
        filter_object(property, "=", property_id),
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query)
  end

  private

  def default_sort
    'updated_at:desc'
  end

  def work_packages_with_query_path(query)
    work_packages_path(query_props: query.to_json)
  end

  def project_work_packages_with_query_path(project, query)
    project_work_packages_path(project, query_props: query.to_json)
  end

  def filter_object(property, operator, values = nil)
    f = {
      n: property,
      o: operator,
    }
    f = f.reverse_merge({ v: values }) if values
    f
  end
end