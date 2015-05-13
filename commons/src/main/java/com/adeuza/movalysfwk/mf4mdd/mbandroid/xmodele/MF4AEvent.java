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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele;

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MActionInterface;
import com.a2a.adjava.xmodele.SGeneratedElement;

/**
 * <p>TODO Décrire la classe MEvent</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public class MF4AEvent extends SGeneratedElement {

	private MF4AEventType type;
	
	private MActionInterface action;

	public MF4AEvent(MActionInterface p_oAction, MF4AEventType p_oType) {
		super("event", null, p_oType.computeEventName(p_oAction.getEntity().getMasterInterface().getName()));
		this.setFullName(p_oAction.getFullName() + '.' + this.getName());
		this.action = p_oAction;
		this.type = p_oType;
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.SGeneratedElement#toXml()
	 */
	@Override
	public Element toXml() {
		Element r_xEvent = super.toXml();

		r_xEvent.addAttribute("type", this.type.name());

		Element xElement = r_xEvent.addElement("action");
		xElement.addAttribute("name", this.action.getName());
		xElement.addAttribute("full-name", this.action.getFullName());

		xElement = r_xEvent.addElement("entity");
		xElement.addAttribute("name", this.action.getEntity().getMasterInterface().getName());
		xElement.addAttribute("full-name", this.action.getEntity().getMasterInterface().getFullName());
		return r_xEvent;
	}
}
