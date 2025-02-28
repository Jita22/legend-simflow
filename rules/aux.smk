# Copyright (C) 2023 Luigi Pertoldi <gipert@pm.me>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

for tier, simid, _ in simconfigs:

    rule:
        """Produces plots for the primary event vertices."""
        input:
            aggregate.gen_list_of_simid_outputs(config, tier, simid, max_files=5),
        output:
            Path(patterns.plots_file_path(config, tier=tier, simid=simid))
            / f"mage-event-vertices-tier_{tier}.png",
        priority: 100  # prioritize producing the needed input files over the others
        shell:
            (
                " ".join(config["execenv"])
                + " python "
                + workflow.source_path("../scripts/plot_mage_vertices.py")
                + " -b -o {output} {input}"
            )


rule print_stats:
    """Prints a table with summary runtime information for each `simid`.
    No wildcards are used.
    """
    localrule: True
    script:
        "../scripts/print_simprod_stats.py"


rule print_benchmark_stats:
    """Prints a table with summary runtime information of a benchmarking run.
    No wildcards are used.
    """
    localrule: True
    script:
        "../scripts/print_benchmark_stats.py"


rule inspect_simjob_logs:
    """Reports any warning from the simulation job logs."""
    localrule: True
    params:
        logdir=config["paths"]["log"],
    script:
        "../scripts/inspect_MaGe_logs.sh"
