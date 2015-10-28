/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.xmodele;

import com.a2a.adjava.utils.ToXmlUtils;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

/**
 *
 */
public class MF4WNavigation extends MNavigation {

	/**
	 * @param p_sName
	 * @param p_oNavigationType
	 * @param source
	 * @param target
	 */
	public MF4WNavigation(String p_sName, MNavigationType p_oNavigationType, MScreen source, MScreen target) {
		super(p_sName, p_oNavigationType, source, target);
	}

	/**
	 * (@inh)
	 * @see com.a2a.adjava.xmodele.ui.navigation.MNavigation#toXml()
	 */
	@Override
	public Element toXml() {
		Element r_xElem = DocumentHelper.createElement("navigation");
		r_xElem.addAttribute("type", this.getNavigationType().name());
		r_xElem.addAttribute("name", this.getName());

		if (this.getTarget() != null) {
			r_xElem.addAttribute("internal", Boolean.toString(this.getTarget().equals(this.getSource())));
		} else {
			r_xElem.addAttribute("internal", Boolean.toString(false));
		}

		Element xSource = r_xElem.addElement("source");
		xSource.addElement("name").setText(this.getSource().getName());
		xSource.addElement("name-lowercase").setText(this.getSource().getName().toLowerCase());
		xSource.addElement("full-name").setText(this.getSource().getFullName());
		ToXmlUtils.addImplements(xSource, this.getSource().getMasterInterface());

		Element xTarget = r_xElem.addElement("target");
		if (this.getTarget() != null) {
			xTarget.addElement("name").setText(this.getTarget().getName());
			xTarget.addElement("vm-name").setText(this.getTarget().getViewModel().getName());
			xTarget.addElement("name-lc").setText(this.getTarget().getName().toLowerCase());
			xTarget.addElement("full-name").setText(this.getTarget().getFullName());

			if ( this.getTargetPageIdx() != -1 ) {
				xTarget.addElement("page-idx").setText(Integer.toString(this.getTargetPageIdx()));
			}
			ToXmlUtils.addImplements(xTarget, this.getTarget().getMasterInterface());
		}

		if (this.getSourcePage() != null) {
			Element sourcePageElt = r_xElem.addElement("sourcePage");
			sourcePageElt.addElement("name")
				.setText(this.getSourcePage().getName());
		}
		return r_xElem;
	}
}
