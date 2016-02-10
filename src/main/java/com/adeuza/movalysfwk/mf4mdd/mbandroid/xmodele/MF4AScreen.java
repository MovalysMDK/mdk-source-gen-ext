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

import java.util.ArrayList;
import java.util.Collection;

import org.dom4j.Element;

import com.a2a.adjava.languages.android.xmodele.MAndroidScreen;
import com.a2a.adjava.xmodele.MPackage;

/**
 * @author lmichenaud
 *
 */
public class MF4AScreen extends MAndroidScreen {

	/**
	 * Constant name for request code to navigate to screen
	 */
	private String requestCodeConstant ;

	private Collection<MF4AEvent> listenEvents;

	/**
	 * @return
	 */
	public String getRequestCodeConstant() {
		return requestCodeConstant;
	}

	/**
	 * @param p_sUmlName
	 * @param p_sName
	 * @param p_oPackage
	 */
	protected MF4AScreen(String p_sUmlName, String p_sName, MPackage p_oPackage) {
		super(p_sUmlName, p_sName, p_oPackage);
		this.requestCodeConstant = "REQUEST_CODE";
		this.listenEvents = new ArrayList<MF4AEvent>();
	}

	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.xmodele.MScreen#toXmlInsertBeforeDocumentation(org.dom4j.Element)
	 */
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);
		p_xElement.addElement("request-code-constant").setText(requestCodeConstant);

		Element xEvents = p_xElement.addElement("events");
		for (MF4AEvent oEvent : this.listenEvents) {
			xEvents.add(oEvent.toXml());
		}
		
	}
	
	@Override
	public boolean isMultiPanel() {
		return this.getPages().size()>0;
	}
	
	/**
	 * add listened events
	 */
	public void addListenEvents(MF4AEvent p_oEvent) {
		this.listenEvents.add(p_oEvent);
	}

	/**
	 * get listened events list
	 */
	public Collection<MF4AEvent> getListenEvents() {
		return this.listenEvents;
	}
}
