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

import com.a2a.adjava.xmodele.MActionInterface;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;

/**
 * <p>Action interface for MF4A</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */
public class MF4AActionInterface extends MActionInterface {

	/**
	 * Events launched by action
	 */
	private Collection<MF4AEvent> events;

	/**
	 * TODO Décrire le constructeur MF4AActionInterface
	 * @param p_sName
	 * @param p_bRoot
	 * @param p_oPackage
	 * @param p_sInNameClass
	 * @param p_sOutNameClass
	 * @param p_sStepClass
	 * @param p_sProgressClass
	 * @param p_oEntity
	 */
	public MF4AActionInterface(String p_sName, boolean p_bRoot, MPackage p_oPackage, String p_sInNameClass, String p_sOutNameClass,
			String p_sStepClass, String p_sProgressClass, MEntityImpl p_oEntity, MActionType p_oActionType) {
		super(p_sName, p_bRoot, p_oPackage, p_sInNameClass, p_sOutNameClass, p_sStepClass, p_sProgressClass, p_oEntity, p_oActionType);
		this.events = new ArrayList<MF4AEvent>();
	}

	/**
	 * Add event
	 * @param p_oEvent
	 */
	public void addEvent(MF4AEvent p_oEvent) {
		this.events.add(p_oEvent);
	}

	/**
	 * Return events
	 * @return
	 */
	public Collection<MF4AEvent> getEvents() {
		return this.events;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);

		if (this.events != null && !this.events.isEmpty()) {
			Element xEvents = p_xElement.addElement("events");
			for (MF4AEvent oEvent : this.events) {
				xEvents.add(oEvent.toXml());
			}
		}
	}
}
