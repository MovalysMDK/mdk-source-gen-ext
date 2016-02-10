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

import java.util.Collection;
import java.util.List;

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionInterface;
import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MViewModelImpl;

/**
 * <p>TODO Décrire la classe MF4AAction</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public class MF4AAction extends MAction {

	/**
	 * TODO Décrire le constructeur MF4AAction
	 * @param p_sName
	 * @param p_bIsRoot
	 * @param p_oPackage
	 * @param p_oType
	 * @param p_oViewModel
	 * @param p_oDao
	 * @param p_listExternalDaos
	 * @param p_sCreatorName
	 */
	public MF4AAction(String p_sName, MActionInterface p_oActionInterface, boolean p_bIsRoot, MPackage p_oPackage, MViewModelImpl p_oViewModel,
			MDaoInterface p_oDao, List<MDaoInterface> p_listExternalDaos, String p_sCreatorName) {
		super(p_sName, p_oActionInterface, p_bIsRoot, p_oPackage, p_oViewModel, p_oDao, p_listExternalDaos, p_sCreatorName);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);

		Collection<MF4AEvent> oEvents = ((MF4AActionInterface) this.getMasterInterface()).getEvents();
		if (oEvents != null && !oEvents.isEmpty()) {
			Element xEvents = p_xElement.addElement("events");
			for (MF4AEvent oEvent : oEvents) {
				xEvents.add(oEvent.toXml());
			}
		}
	}
}
